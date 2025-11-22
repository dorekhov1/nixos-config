{ config, ... }:

{
    home-manager.users.${config.user} = {
        programs.git = {
            enable = true;

            settings = {
                user.name = "Daniil Orekhov";
                user.email = "daniil.orekhov15@gmail.com";
                credential.helper = "store";
                core.askPass = "";
                http.lowSpeedLimit = 1000;
                http.lowSpeedTime = 60;
            };
        };
    };
}
