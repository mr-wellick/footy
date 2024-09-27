import { FC } from "hono/jsx";
import Navbar from "./components/navbar";
import { render } from "hono/jsx/dom";
import Hero from "./components/hero";
import Footer from "./components/footer";

const App: FC = () => {
  return (
    <>
      <Navbar />
      <Hero />
      <Footer />
    </>
  );
};

const root = document.getElementById("root");
render(<App />, root!);
