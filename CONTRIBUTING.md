# Contributor's Guide

Hasty guidelines for contributing content to P2docs.

(if anything needs clarification please raise an issue or otherwise contact me)

## Read the README

This contains useful information, too.

## Formatting

This webpage uses _SiteGen!_ which in turn uses [Kramdown](https://kramdown.gettalong.org/index.html) to render markdown documents. Kramdown's native syntax is slightly different to GFM, which you may be more familiar with - most notably, code blocks are fenced with triple tildes instead of triple backticks and in most cases have to be preceded by a blank line to render correctly

### ERB and templating

The Markdown syntax has been extended with ERB templating. A tag of the form `<%=foobar%>` will insert the result of the Ruby expression `foobar` into _the HTML output_ (there is no Markdown parsing for template content).

Template functions are automatically loaded from the `template` directory (themselves being HTML/ERB documents), but regular Ruby functions and operators can be used as well.

### Make sure your change renders correctly

Follow the instructions in README.md to render and host the page locally to check that your change looks good before submitting a pull request.

## Style

This is hard to formalize, but try to emulate the style of the previous text (especially the "good" text that isn't littered with hasty TODOs).

### No LLM slop

![NO LLMs ON PREMISES](common/NoLLMS.png)

Under no circumstances use an LLM or other "AI"-type software to generate contributions or any parts thereof.

### Accuracy

Please write all text yourself (or copy/adapt it from first-hand sources) and verify its accuracy. If you're not sure about something, leave a TODO in the text. This signals that the information is not complete/reliable yet.
