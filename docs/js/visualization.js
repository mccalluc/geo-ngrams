async function main() {
  const response = await fetch('data/bigrams.json');
  const bigrams = await response.json();

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
    width: 50,
    height: 30,
    data: {values: bigrams},
    mark: 'text',
    encoding: {
      x: {field: 'norm', type: 'quantitative', title: null},
      y: {field: 'count', type: 'quantitative', title: null},
      text: {field: 'ngram'},
      row: {field: 'lat', title: "latitude / count"},
      column: {field: "long", title: "longitude / norm"}
    }
  }

  console.log(JSON.stringify(trellisSpec, null, 2))
  const spec = {
    $schema: "https://vega.github.io/schema/vega-lite/v5.json",
    vconcat: [mapSpec, trellisSpec]
  };
  vegaEmbed('#vis', spec);
}

main();