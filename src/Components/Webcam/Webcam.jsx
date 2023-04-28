import React, { useState, useEffect } from "react";

import "./Webcam.scss";

const Webcam = ({ userLabel }) => {
  const [videoTrack, setVideoTrack] = useState(null);
  const [isLarge, setIsLarge] = useState(false);

  useEffect(() => {
    navigator.mediaDevices
      .getUserMedia({ video: true })
      .then((stream) => {
        const videoTrack = stream.getVideoTracks()[0];
        setVideoTrack(videoTrack);
      })
      .catch((error) => {
        console.error(error);
      });
  }, []);

  const toggleSize = () => {
    setIsLarge(!isLarge);
  };

  // Styles
  const videoStyles = {
    width: isLarge ? "55%" : "35%",
  };

  return (
    <>
      {videoTrack ? (
        <div className="webcam-container">
          <video
            className="webcam"
            onClick={toggleSize}
            style={videoStyles}
            autoPlay
            muted
            ref={(videoElement) => {
              if (videoElement && videoTrack) {
                videoElement.srcObject = new MediaStream([videoTrack]);
              }
            }}
          />
          {/* <p className="label">{userLabel}</p> */}
        </div>
      ) : (
        <p>Waiting for video stream...</p>
      )}
    </>
  );
};

export default Webcam;
