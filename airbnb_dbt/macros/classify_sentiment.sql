{% macro classify_sentiment(comment_column) %}

case
    when {{ comment_column }} is null
      or trim({{ comment_column }}) = ''
        then 'Unknown'

    when regexp_like(
        lower({{ comment_column }}),
        '.*\\b(great|excellent|nice|good|amazing|wonderful|perfect|clean|comfortable|friendly|lovely|love|loved|recommend|charming|beautiful|happy|satisfied)\\b.*'
    )
        then 'Positive'

    when regexp_like(
        lower({{ comment_column }}),
        '.*\\b(bad|terrible|awful|dirty|broken|noisy|noise|smell|worst|uncomfortable)\\b.*'
    )
        then 'Negative'

    else 'Neutral'
end

{% endmacro %}