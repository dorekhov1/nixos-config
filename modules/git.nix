{ config, ... }:

{
    home-manager.users.${config.user} = {
        programs.git = {
            enable = true;

            userName = "Daniil Orekhov";
            userEmail = "daniil.orekhov15@gmail.com";
        };
    };
}
