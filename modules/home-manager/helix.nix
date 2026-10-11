{...}:
{
  programs.helix = {
    settings = {
      theme = "ayu_evolve";
      editor = {
        cursor-shape = {
          insert = "bar";
          normal = "underline";
          select = "block";
        };
        statusline = {
          left = ["mode" "spinner" "version-control" "file-name" "file-modification-indicator"];
          right = ["diagnostics" "selections" "position" "separator" "file-encoding" "total-line-numbers"];
        };
        lsp = {
          auto-signature-help = true;
        };
        auto-pairs = {
          "<" = ">";
          "[" = "]";
          "{" = "}";
          "(" = ")";
          "'" = "'";
          "`" = "`";
          "\"" = "\"";
        };
        indent-guides = {
          render = true;
          character = "┊";
          skip-levels = 1;
        };
        soft-wrap = {
          # enable = true;
          max-wrap = 25;
        };
      };
    };
    languages = {
      language = [{
        name = "Checked Text";
        language-servers = [{name = "ltex";}];
        file-types = ["txt"];
        scope = "text.text";
        roots = [];
        comment-tokens = ["# "];
      }];
      language-server.ltex = {
        command = "ltex-ls-plus";
      };
    };
  };
}
