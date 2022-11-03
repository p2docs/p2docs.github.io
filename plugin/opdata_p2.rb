# encoding: utf-8
# frozen_string_literal: true

# P2 Opcode data extractor

require 'csv'

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
    colorspace: "Color Space Converter",
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

P2InstEntry = Struct.new(:name,:args,:flags,:category,:enctext,:alias,:time_cog,:time_hub,:shield,:regwr,keyword_init: true) do

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

end

P2Instructions = Array.new()

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
    next if row[:alias] == 'alias'
    p row[:syntax] unless row[:syntax] =~ /^([\w<>]+)(?: {1,6}([{#}\w\/\\]+)(?:,?([{#}\w\/\\]+)(?:,?([{#}\w\/\\]+))?)?)?(?: +({)?([A-Z\/]+)}?)?$/
    if $1 == "<empty>"
        categ = :empty
    end
    name = $1
    flags = ($6||'').upcase.split(?/).map(&:to_sym)
    flags.unshift :none if $5 == '{' || flags.empty?
    args = []
    add_arg(args,$2)
    add_arg(args,$3)
    add_arg(args,$4)

    p row[:encoding] unless row[:encoding] =~ /^(\w{4}) (\w{7}) (\w)(\w)(\w) (\w{9}) (\w{9})$/

    P2Instructions << P2InstEntry.new(
        name: name,
        args: args,
        enctext: row[:encoding],
        regwr: row[:regwr] || "none",
        flags: flags,
        shield: row[:shield] == '✔',
        category: categ,
        time_cog: fixup_cycles(row[:time8cog]),
        time_hub: fixup_cycles(row[:time8hub]=="same" ? row[:time8cog] : row[:time8hub]),
    )
end

end

