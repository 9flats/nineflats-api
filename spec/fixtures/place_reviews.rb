class Fixtures
  def self.place_reviews
    '{
      "total": 2,
      "reviews": [{
        "review": {
          "user_text": "Jan is a really nice outgoing person. I had a great time at his place. You should ask him for that tastey Polish vodka!!",
          "place_text": "It\'s a nice and lovely flat in a really great area of cologne. everything is in walking distance and it is great start to explore the cologne and its nightlife.",
          "place_stars": 5,
          "language": "en"
        }
      },
      {
        "review": {
          "user_text": "Ich habe mich sehr gefreut, dass Jan abends ein paar Stunden Zeit fuer mich hatte um mir Koeln bei Nacht zu zeigen und mich mit einem ungefilterten Superzeug bekannt machte.",
          "place_text": "Authentisches und persoenliches wohnen, in Jans Wohnung im Superviertel. Alles da was man braucht und nicht so steril wie Ferienwohnungen oft sind. I LIKE.",
          "place_stars": 5,
          "language": "de"
        }
      }]
    }'
  end
end
