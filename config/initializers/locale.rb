require 'i18n'

I18n.load_path += Dir['config/locales/**/*.yml']
I18n.backend.load_translations