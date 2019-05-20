import React, { useState } from "react";
import Dropzone from "./Dropzone";
import Results from "./Results";
import "./App.css";

function App() {
  const [predictions, setPredictions] = useState([]);
  console.log("Predictions:");
  console.log(predictions);
  return (
    <div className="App">
      <h2>SNES Game Image Classifier</h2>
      <div style={{ marginBottom: "20px" }}>
        Given a screenshot of any Super Nintendo game, this model will guess
        which game it belongs to. <br />
        Does poorly with title screens or endings. <br />
        Larger writeup forthcoming. <br />
      </div>
      <Dropzone setPredictions={setPredictions} />
      <Results predictions={predictions} />
    </div>
  );
}

export default App;
