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
    hubmem: "Hub RAM",
    lutmem: "LUT RAM",
    fifo: "Hub FIFO",
    pin: "Pins",
    modcz: "MODCZ Operand",
    streamer: "Streamer",
    colorspace: "Color Space Converter",
    event: "Events",
    irq: "Interrupts",
    branch: "Branching",
    ctrl: "Hub Control",
    empty: "Empty opcode",
}

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
        :ctrl
    when /MODCZ Operand/,/Instruction Prefix/
        nil # Doesn't count as instruction
    else
        :misc
    end

end

P2InstEntry = Struct.new(:name,:dest,:source,:extra,:flags,:category,:alias,keyword_init: true)

P2Instructions = Array.new()

tab = CSV.new(
    File.read("data/p2ops.csv").gsub(?\u{A0},' '), # Stupid NBSPs
    headers: %i[order syntax group encoding alias description shield time8cog time8hub time16cog time16hub regwr hubrw stackrw]
)
header = tab.shift

tab.each do |row|
    categ = select_category(row[:group])
    next if categ.nil?
    p row[:syntax] unless row[:syntax] =~ /^([\w<>]+)(?: +([{#}\w\/\\]+)(?:,?([{#}\w\/\\]+)(?:,?([{#}\w\/\\]+))?)?)?(?: +({)?([A-Z\/]+)}?)?$/
    if $1 == "<empty>"
        categ = :empty
    end
    flags = ($6||'').downcase.split(?/).map(&:to_sym)
    flags << :none if $5 == '{' || flags.empty?
    P2Instructions << P2InstEntry.new(
        name: $1,
        flags: flags,
        category: categ,
        alias: row[:alias] == 'alias'
    )
end

end

