{ config, pkgs, ... }: {
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;
    package = pkgs.ollama-cuda;
    # environmentVariables = {
    #   "CUDA_VISIBLE_DEVICES" = "0";
    #   "NVIDIA_VISIBLE_DEVICES" = "all";
    #   "GPU_LAYERS" = "29";  # Force all layers to GPU
    #   "OLLAMA_CUDA" = "1";
    #   "OLLAMA_GPU_LAYERS" = "29";  # Another way to force GPU layers
    # };
  };

  environment.systemPackages = with pkgs; [ ollama-cuda ];
}
