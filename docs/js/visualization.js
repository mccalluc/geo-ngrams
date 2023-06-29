async function main() {
  const response = await fetch('data/ngrams.json');
  const ngrams = await response.json();

  const mapSpec = {
    width: 500,
    height: 300,
    projection: {
      type: "albersUsa"
    },
    layer: [
      {
        data: {
          url: "data/topo.json",
          format: {
            type: "topojson",
            feature: "states"
          }
        },
        mark: {
          type: "geoshape",
          fill: "lightgray",
          stroke: "white"
        }
      }
    ]
  }
  const trellisSpec = {
    width: 60,
    height: 60,
    spacing: 0,
    data: {values: ngrams},
    mark: {type: 'text', fontSize: 8},
    encoding: {
      x: {field: 'norm', type: 'quantitative', title: null},
      y: {field: 'count', type: 'quantitative', title: null},
      text: {field: 'ngram'},
      row: {field: 'lat', title: "latitude; count", sort: "descending"},
      column: {field: "long", title: "longitude; log2(ratio)"}
    }
  }

  const spec = {
    $schema: "https://vega.github.io/schema/vega-lite/v5.json",
    vconcat: [mapSpec, trellisSpec]
  };
  vegaEmbed('#vis', spec);
}

main();