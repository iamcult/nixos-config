let
  cult = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID2PJseLNwbHPPN4cjfmFm7anSf9BYnL4cee1sTi3P4I";
  users = [ cult ];

  thing = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPTUsHxqTKHsx8A4QsB/B921zf4rv8pQsea+Un5Ptvb2";
  systems = [ thing ];
in
{
  "password.age".publicKeys = [ cult thing ];
}
