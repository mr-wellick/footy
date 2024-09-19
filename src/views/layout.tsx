import type { FC } from "hono/jsx";
import Navbar from "./components/navbar";
import Leagues from "./components/leagues";

const Layout: FC = () => {
  return (
    <>
      <Navbar />
      <Leagues />
    </>
  );
};

export default Layout;
