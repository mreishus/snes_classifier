import React from "react";

const perc = num => (num * 100).toFixed(2) + "%";

function Results({ predictions }) {
  if (predictions.length === 0) {
    return null;
  }

  const other_predictions = predictions.slice(1, 5).filter(x => x[1] > 0.01);

  return (
    <div>
      <h3>Prediction:</h3>
      <ol>
        <li style={{ fontSize: "48px" }}>
          {predictions[0][0]} {perc(predictions[0][1])}
        </li>
        {other_predictions.map(x => (
          <li>
            {x[0]} {perc(x[1])}
          </li>
        ))}
      </ol>
    </div>
  );
}
export default Results;
