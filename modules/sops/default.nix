{ config, ... }: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age = {
      keyFile = "/persist/system/sops/age/keys.txt";
      generateKey = false;
    };
    secrets.password = {
      neededForUsers = true;
    };
  };
}
