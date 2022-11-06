# encoding: utf-8
# frozen_string_literal: true

# P2 Opcode data extractor

require 'csv'
require 'yaml'

module P2Opdata

CATEGORIES = {
    misc: "Other",
    alu: "Math and Logic",
    cordic: "CORDIC",
    indir: "Register Indirection",
    mixpix: "Pixel Mixer",
    hubmem: "Hub Memory",
    lutmem: "LUT Memory",
    fifo: "Hub FIFO",
    pin: "Pins",
    modcz: "MODCZ Operand",
    streamer: "Streamer",
    colorspace: "Colorspace Converter",
    event: "Events",
    irq: "Interrupts",
    branch: "Branching",
    hubctrl: "Hub Control",
    empty: "Empty opcode",
}

EVENTS = %w[int ct1 ct2 ct3 se1 se2 se3 se4 pat fbw xmt xfi xro xrl atn qmt].freeze

def self.select_category(str)
    case str
    when /Math and Logic/
        :alu
    when /Register Indirection/
        :indir
    when /Pixel Mixer/
        :mixpix
    when /Hub RAM/
        :hubmem
    when /Lookup Table/
        :lutmem
    when /Hub FIFO/
        :fifo
    when /Streamer/
        :streamer
    when /Events - Branch/
        :branch
    when /Events/
        :event
    when /Interrupts/
        :irq
    when /Pins/
        :pin
    when /Color Space Converter/
        :colorspace
    when /CORDIC/
        :cordic
    when /Branch/
        :branch
    when /Hub Control/
        :hubctrl
    when /MODCZ Operand/,/Instruction Prefix/
        nil # Doesn't count as instruction
    else
        :misc
    end
end

ARGTYPES = {
    dest_either: '{#}D',
    dest_reg: 'D',
    src_either: '{#}S',
    src_reg: 'S',
    ptrexpr: '{#}S/P',
    preg: 'PA/PB/PTRA/PTRB',
    selector: '#N',
    address: '#{\}A',
    augment: '#n',
    c_remap: 'c',
    z_remap: 'z',
}

def self.add_arg(array,str)
    return nil if str.nil? || str.empty?
    a = ARGTYPES.key(str)
    raise "unknown ARGTYPE #{str}" unless a
    array << a
    return a
end

P2InstEntry = Struct.new(
    :id, :name, :extra,:search_prefer,:args,:flags,:category,:enctext,:alias,:time_cog,:time_hub,:shield,:regwr,:cval,:zval,:opc_main,:opc_s,:shortdesc,:setq,
keyword_init: true) do

    def flagsyntax
        have_none = flags.include? :none
        if have_none && flags.size == 1
            return ""
        else
            str = (flags - [:none]).join(?/)
            str = '{' + str + '}' if have_none
            return str
        end
    end

    def argsyntax
        args.map{|s|ARGTYPES[s]}.join(?,)
    end

    def doc_href
        "/#{category}.html##{id}"
    end

end

P2Instructions = Array.new()

SHORTDESCS = YAML.load(File.read("data/shortdesc.yml"))

CSVDATA = CSV.new(
    File.read("data/p2ops.csv").gsub(?\u{A0},' '), # Stupid NBSPs
    headers: %i[order syntax group encoding alias description shield time8cog time8hub time16cog time16hub regwr hubrw stackrw]
).freeze
tab = CSVDATA.dup
header = tab.shift

def self.fixup_cycles(str)
    str ||= "FAIL"
    str = str.dup
    str.gsub!('...','..') # .. is the correct syntax for inclusive range
    if str.end_with? '*' # "+1 if unaligned" (should be explained in description)
        str.gsub!(/ ?\*$/,'')
        str.gsub!(/\d+$/){|n|((n.to_i)+1).to_s}
    end
    return str
end

tab.each do |row|
    categ = select_category(row[:group])
    next if categ.nil?
    p row[:syntax] unless row[:syntax] =~ /^([\w<>]+)(?: {1,6}([{#}\w\/\\]+)(?:,?([{#}\w\/\\]+)(?:,?([{#}\w\/\\]+))?)?)?(?: +({)?([A-Z\/]+)}?)?$/
    if $1 == "<empty>"
        categ = :empty
    end
    name = $1
    next if row[:alias] == 'alias' && P2Instructions.any?{|i|i.name==name}

    flags = ($6||'').upcase.split(?/).map(&:to_sym)
    flags.unshift :none if $5 == '{' || flags.empty?
    args = []
    add_arg(args,$2)
    add_arg(args,$3)
    add_arg(args,$4)

    categ = :irq if name =~ /^RE[TS]I[0-3]$/

    if args.include? :z_remap
        zval = "Per zzzz"
    elsif !flags.any?{|f|f=~/z/i}
        zval = "---"
    elsif name =~ /^POLL(\w+)/
        zval = "#{$1} event occurred"
    elsif name == "GETBRK"
        zval = "head hurts"
    elsif row[:description] =~ / \*(?: +Prior.+)?$/
        zval = "Result == 0"
    elsif row[:description] =~ /Z = (.+?)(?:[,.] *PC =.+)?$/
        zval = $1.strip.chomp(?.).strip.gsub("Result","Result")
    else
        p name
        zval = "???"
    end

    regwr= row[:regwr] || "none"

    if args.include? :c_remap
        cval = "Per cccc"
    elsif name == "CMPSUB"
        cval = "D >= S"
    elsif name == "INCMOD"
        cval = "D == S"
    elsif name == "DECMOD"
        cval = "D == 0"
    elsif name == "LOCKTRY"
        cval = "1 if got LOCK"
    elsif name == "LOCKREL"
        cval = "LOCK status"
        regwr = "D if reg and WC" # Table mistake
    elsif name == "GETBRK"
        cval = "owie ouch"
    elsif name =~ /^FGE/
        cval = "D < S"
    elsif name =~ /^FLE/
        cval = "D > S"
    elsif name =~ /^POLL(\w+)/
        cval = "#{$1} event occured"
    elsif !flags.any?{|f|f=~/c/i}
        cval = "---"
    elsif row[:description] =~ /(?<!P)C(?:\/Z)? = (?!.*[^P]C =)(.+?)(?:[,.] *Z =.+)?(?: \*(?: +Prior.+)?)?$/
        cval = $1.strip.chomp(?.).strip
    elsif !flags.include?(:wc) && row[:description] =~ /C,Z = /
        cval = zval
    else
        p name
        cval = "???"
    end

    setq = nil

    setq = 1 if row[:description] =~ /setq/i
    setq = 2 if row[:description] =~ /setq2/i

    p row[:encoding] unless row[:encoding] =~ /^(\w{4}) (\w{7}) (\w)(\w)(\w) (\w{9}) (\w{9})$/
    openc = $2
    denc = $6
    senc = $7

    if name == "JMP" || name =~ /^CALL[AB]?$/
        extra = args[0] == :address ? "(A)" : "(D)"
        search_prefer = args[0] == :address
    elsif name == "CALLD"
        extra = args[1] == :address ? "(A)" : "(S)"
        search_prefer = args[0] == :address
    elsif name =~ /^TEST[BP]N?$/
        extra = '('+flags[0].to_s.chop+')' unless flags.include? :WZ
    else
        extra = nil
        search_prefer = nil
    end

    id = [name,extra].compact.join('-').downcase.gsub(/[^A-Za-z0-9\-]/,'')

    P2Instructions << P2InstEntry.new(
        id: id,
        name: name,
        extra: extra,
        search_prefer: search_prefer,
        args: args,
        enctext: row[:encoding],
        regwr: regwr,
        zval: zval,
        cval: cval,
        flags: flags,
        shield: row[:shield] == '✔',
        category: categ,
        time_cog: fixup_cycles(row[:time8cog]),
        time_hub: fixup_cycles(row[:time8hub]=="same" ? row[:time8cog] : row[:time8hub]),
        opc_main: (openc =~ /^[01]+$/) ? openc.to_i(2) : nil,
        opc_s: (openc =~ /^[01]+$/) ? senc.to_i(2) : nil,
        shortdesc: SHORTDESCS[id.upcase],
        setq: setq,
    )
end

P2SmartEntry = Struct.new(:name,:number,:shortdesc) do
    def id
        return @id if @id
        return @id = name.downcase.gsub('_','-')
    end
    def doc_href
        "/pin.html##{id}"
    end
end

P2SmartModes = [
    P2SmartEntry["P_NORMAL",0b00000,"Dumb pin mode"],
    P2SmartEntry["P_REPOSITORY",0b00001,"Long repository"],
    P2SmartEntry["P_DAC_NOISE",0b00001,"DAC Noise"],
    P2SmartEntry["P_DAC_DITHER_RND",0b00010,"DAC 16-bit random dither"],
    P2SmartEntry["P_DAC_DITHER_PWM",0b00011,"DAC 16-bit PWM dither"],

    P2SmartEntry["P_PULSE",0b00100,"Pulse/cycle output"],
    P2SmartEntry["P_TRANSITION",0b00101,"Transition output"],
    P2SmartEntry["P_NCO_FREQ",0b00110,"NCO frequency output"],
    P2SmartEntry["P_NCO_DUTY",0b00111,"NCO duty output"],

    P2SmartEntry["P_PWM_TRIANGLE",0b01000,"PWM triangle output"],
    P2SmartEntry["P_PWM_SAWTOOTH",0b01001,"PWM sawtooth output"],
    P2SmartEntry["P_PWM_SMPS",0b01010,"PWM switch-mode power supply I/O"],
    P2SmartEntry["P_QUADRATURE",0b01011,"A-B quadrature encoder input"],

    P2SmartEntry["P_REG_UP",0b01100,"Inc on A-rise when B-high"],
    P2SmartEntry["P_REG_UP_DOWN",0b01101,"Inc on A-rise when B-high, dec on A-rise when B-low"],
    P2SmartEntry["P_COUNT_RISES",0b01110,"Inc on A-rise, optionally dec on B-rise"],
    P2SmartEntry["P_COUNT_HIGHS",0b01111,"Inc on A-high, optionally dec on B-high"],

    P2SmartEntry["P_STATE_TICKS",0b10000,"For A-low and A-high states, count ticks"],
    P2SmartEntry["P_HIGH_TICKS",0b10001,"For A-high states, count ticks"],
    P2SmartEntry["P_EVENTS_TICKS",0b10010,"For X A-highs/rises/edges, count ticks / Timeout on X ticks of no A-high/rise/edge"],
    P2SmartEntry["P_PERIODS_TICKS",0b10011,"For X periods of A, count ticks"],

    
    P2SmartEntry["P_PERIODS_HIGHS",0b10100,"For X periods of A, count highs"],
    P2SmartEntry["P_COUNTER_TICKS",0b10101,"For periods of A in X+ ticks, count ticks"],
    P2SmartEntry["P_COUNTER_HIGHS",0b10110,"For periods of A in X+ ticks, count highs"],
    P2SmartEntry["P_COUNTER_PERIODS",0b10111,"For periods of A in X+ ticks, count periods"],

    P2SmartEntry["P_ADC",0b11000,"ADC sample/filter/capture, internally clocked"],
    P2SmartEntry["P_ADC_EXT",0b11001,"ADC sample/filter/capture, externally clocked"],
    P2SmartEntry["P_ADC_SCOPE",0b11010,"ADC scope with trigger"],
    P2SmartEntry["P_USB_PAIR",0b11011,"USB pin pair"],

    P2SmartEntry["P_SYNC_TX",0b11100,"Synchronous serial transmit"],
    P2SmartEntry["P_SYNC_RX",0b11101,"Synchronous serial receive"],
    P2SmartEntry["P_ASYNC_TX",0b11110,"Asynchronous serial transmit"],
    P2SmartEntry["P_ASYNC_RX",0b11111,"Asynchronous serial receive"],
]

end

