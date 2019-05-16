import React, { useCallback } from "react";
import { useDropzone } from "react-dropzone";

function Dropzone({ setPredictions }) {
  const sendFileToBackend = useCallback(
    file => {
      var formData = new FormData();
      formData.append("file", file);

      fetch("/upload", {
        method: "POST",
        body: formData
      })
        .then(response => response.json())
        .then(myJson => {
          if (myJson.predictions) {
            setPredictions(myJson.predictions);
          }
        });
    },
    [setPredictions]
  );

  const onDrop = useCallback(
    acceptedFiles => {
      const reader = new FileReader();

      reader.onabort = () => console.log("file reading was aborted");
      reader.onerror = () => console.log("file reading has failed");
      reader.onload = () => {
        // Do whatever you want with the file contents
        const b64Str = reader.result;
        console.log(b64Str);
        sendFileToBackend(b64Str);
      };

      acceptedFiles.forEach(file => reader.readAsDataURL(file));
    },
    [sendFileToBackend]
  );

  const { getRootProps, getInputProps /*, isDragActive */ } = useDropzone({
    onDrop
  });

  return (
    <div {...getRootProps()}>
      <div style={{ border: "3px dashed white", padding: "20px" }}>
        <input {...getInputProps()} />
        <p>Drag and drop an image here, or click to select a file</p>
      </div>
    </div>
  );
}

export default Dropzone;
