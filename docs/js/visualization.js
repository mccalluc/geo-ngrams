async function main() {
  const response = await fetch('bigrams.json');
  const bigrams = await response.json();
  Object.keys(bigrams).forEach((key) => {
    const {lat, long} = JSON.parse(key)
    console.log(lat, long);
  });

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
    ]
  };
  vegaEmbed('#vis', spec);
}

main();