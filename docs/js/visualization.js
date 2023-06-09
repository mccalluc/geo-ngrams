async function main() {
  const response = await fetch('bigrams.json');
  const bigrams = await response.json();
  const buckets = Object.keys(bigrams).map((key) => JSON.parse(key))

  const spec = {
    "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
    "width": 800,
    "height": 500,
    "projection": {
      "type": "albersUsa"
    },
    "layer": [
      {
        "data": {
          "url": "data/topo.json",
          "format": {
            "type": "topojson",
            "feature": "states"
          }
        },
        "mark": {
          "type": "geoshape",
          "fill": "lightgray",
          "stroke": "white"
        }
      },
      {
        "data": {values: buckets},
        "mark": "circle",
        "encoding": {
          "longitude": {
            "field": "long",
            "type": "quantitative"
          },
          "latitude": {
            "field": "lat",
            "type": "quantitative"
          },
        }
      }
    ]
  };
  vegaEmbed('#vis', spec);
}

main();