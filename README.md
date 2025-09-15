
## Quick Orientation

To generate site, run `bundler exec ruby sitegen.rb` (run `bundler install` first if it tells you to).
To host local server on Port 8008, run `ruby -run -e httpd ./out -p 8008` (install webrick first if it tells you to)

Page data lives in `page/`. Is semi-standard markdown with ERB templating.

The main stylesheet is `page/main.scss`.

Templates from `template/` are autoloaded as functions. The call arguments go into `targ` and `kwarg`.

All the P2 Instruction sheet parsing happens in `plugin/opdata_p2.rb`

Images can go into `page/` or `common/`.
