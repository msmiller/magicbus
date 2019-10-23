# This model holds the global config for the app
#
# https://github.com/settingslogic/settingslogic

class Konfig < Settingslogic
  source "#{Rails.root}/config/konfig.yml"
  namespace Rails.env
  suppress_errors Rails.env.production?
  load!

end