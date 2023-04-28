import Webcam from "./Components/Webcam/Webcam";

import "./App.scss";

const App = () => {
  return (
    <div className="App">
      <h1 className="app-title">Sistema de Vigilancia Mesh</h1>
      <div className="webcams-rows">
        <Webcam userLabel={"Usuario 1"} />
      </div>
    </div>
  );
};

export default App;
