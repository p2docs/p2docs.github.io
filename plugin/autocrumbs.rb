# encoding: utf-8
# frozen_string_literal: true

module AutoCrumbs

    def content_postprocess(doc)
        if props['autocrumbs'] == false
            super
        else
            breadcrumbs + super
        end
    end

end

SitePage.prepend(AutoCrumbs)
