import { FC } from "hono/jsx";
import Navbar from "./components/navbar";
import { render } from "hono/jsx/dom";

const App: FC = () => {
  return <Navbar />;
};

const root = document.getElementById("root");
render(<App />, root!);
