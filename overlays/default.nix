final: prev:
let 
  overlays = [
    (import ./base)
  ];
in
prev.lib.compileManyExtensions overlays lib prev