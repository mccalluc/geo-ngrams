async function main() {
  const response = await fetch('data/bigrams.json');
  const bigramBuckets = await response.json();
  const buckets = bigramBuckets.map(bucket => ({lat: bucket.lat, long: bucket.long}));

  const mapSpec = {
    width: 600,
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
      },
      {
        data: {values: buckets},
        mark: "circle",
        encoding: {
          longitude: {
            field: "long",
            type: "quantitative"
          },
          latitude: {
            field: "lat",
            type: "quantitative"
          },
        }
      }
    ]
  }
  const spec = {
    $schema: "https://vega.github.io/schema/vega-lite/v5.json",
    vconcat: [mapSpec, mapSpec]
  };
  vegaEmbed('#vis', spec);
}

main();