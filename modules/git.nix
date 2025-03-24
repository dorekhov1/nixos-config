{ config, ... }:

{
    home-manager.users.${config.user} = {
        programs.git = {
            enable = true;

            userName = "Daniil Orekhov";
            userEmail = "daniil.orekhov15@gmail.com";
            
            # Add credential helper to avoid authentication prompts
            extraConfig = {
                credential.helper = "store";

                # Disable SSH prompting for HTTPS URLs
                core.askPass = "";
                # Set a longer timeout for git operations
                http.lowSpeedLimit = 1000;
                http.lowSpeedTime = 60;
            };
        };
    };
}
