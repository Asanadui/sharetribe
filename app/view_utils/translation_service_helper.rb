module TranslationServiceHelper

  module_function

  def pick_translation(key, community_translations, community_locales, user_locale, opts = {})
    translations_for_key = community_translations.select { |translation| translation[:translation_key] == key }

    raise ArgumentError.new("Can not find any translation for key: #{key}") if translations_for_key.empty?

    preferred = (opts[:locale] || user_locale).to_s
    fallbacks = community_locales.map(&:to_s).reject { |l| l == preferred }
    locales_ordered = [preferred].concat(fallbacks)

    translations_ordered = locales_ordered.map { |l|
      translations_for_key.find { |t| t[:locale] == l }
    }

    (translations_ordered.first || translations_for_key.first)[:translation]
  end
end
