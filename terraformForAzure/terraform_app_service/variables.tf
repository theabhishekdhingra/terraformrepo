variable "webapp_app_settings" { 
    type = map 
    default = {
      WEBSITE_LOAD_CERTIFICATE = "*"
      WEBSITE_TIME_ZONE = "Indian Standard Time"
      WEBSITE_VNET_ROUTE_ALL = 1
    }

}