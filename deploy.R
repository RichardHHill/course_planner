
Sys.setenv(R_CONFIG_ACTIVE = "default")
#Sys.setenv(R_CONFIG_ACTIVE = "production")

config_polish <- config::get(file = "shiny_app/config.yml")
rsconnect::deployApp(
  appDir = "shiny_app",
  account = "richardh",
  appName = config_polish$app_name
)

