{
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    package = pkgs.postgresql_15;
    authentication = pkgs.lib.mkOverride 10 '' 
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE USER admin WITH ENCRYPTED PASSWORD '1131'; 
      CREATE DATABASE data;
      GRANT ALL PRIVILEGES ON DATABASE data To admin;
      ALTER DATABASE data OWNER to admin;
    '';

  }; 

  services.postgresqlBackup =  {
    enable = true;
    startAt = "03:10:00";
    databases = ["data"];
  };
}
