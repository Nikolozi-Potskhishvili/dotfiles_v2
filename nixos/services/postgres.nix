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
      CREATE USER baserow WITH ENCRYPTED PASSWORD 'baserow'; 
      CREATE DATABASE baserow;
      GRANT ALL PRIVILEGES ON DATABASE baserow To baserow;
      ALTER DATABASE baserow OWNER to baserow;
    '';

  }; 

  services.postgresqlBackup =  {
    enable = true;
    startAt = "03:10:00";
    databases = ["baserow"];
  };
}
