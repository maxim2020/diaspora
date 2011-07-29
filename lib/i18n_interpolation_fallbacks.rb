module I18n
  module Backend
    module InterpolationFallbacks

      def translate(locale, key, options = {})
        return super if options[:fallback]
        default = extract_string_or_lambda_default!(options) if options[:default]

        options[:fallback] = true
        I18n.fallbacks[locale].each do |fallback|
          begin
            result = super(fallback, key, options)
            return result unless result.nil?
          rescue I18n::MissingInterpolationArgument
          end
        end
        options.delete(:fallback)

        return super(locale, nil, options.merge(:default => default)) if default
        raise(I18n::MissingInterpolationError.new(locale, key, options))
      end
    end
  end
end
