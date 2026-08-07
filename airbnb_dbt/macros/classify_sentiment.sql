{% macro classify_sentiment(comment_column) %}

case
    when {{ comment_column }} is null
      or trim({{ comment_column }}) = ''
        then 'Unknown'

    when regexp_like(
        lower({{ comment_column }}),
        '.*\\b(great|excellent|amazing|wonderful|perfect|clean|comfortable|friendly|love|loved|recommend)\\b.*'
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