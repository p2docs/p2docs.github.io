# encoding: utf-8
# frozen_string_literal: true

module AnchorLinks

    
    # Wish I could monkey-patch this, but I can't
    def convert_header(el, indent)
        attr = el.attr.dup
        if @options[:auto_ids] && !attr['id']
            attr['id'] = generate_id(el.options[:raw_text])
        end
        @toc << [el.options[:level], attr['id'], el.children] if attr['id'] && in_toc?(el)
        level = output_header_level(el.options[:level])
        inner = inner(el, indent)
        if (el.attr['class'] || '') =~ /\banchor\b/
            inner += "<a class=\"anchor\" href=\"##{attr['id']}\"></a>"
        end
        format_as_block_html("h#{level}", attr, inner, indent)
    end
end

Kramdown::Converter::HtmlCustom.prepend(AnchorLinks)
