{
  description = "My personal flake templates";

  outputs = {self}: {
    templates = {
      rust = {
        path = ./rust;
        description = "Rust development environment";
      };

      # node = {
      #   path = ./node;
      #   description = "Node.js development environment";
      # };
      #
      # python = {
      #   path = ./python;
      #   description = "Python development environment";
      # };
      #
      # go = {
      #   path = ./go;
      #   description = "Go development environment";
      # };
    };
  };
}
