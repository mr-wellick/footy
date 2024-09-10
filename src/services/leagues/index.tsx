import { Hono } from "hono";
import prisma from "../../db";
import { leagues } from "@prisma/client";
import { FC } from "hono/jsx";

const app = new Hono();

export const View: FC<{ leagues: leagues[] }> = (props) => {
  return (
    <>
      <select
        className="select select-accent w-full max-w-xs"
        hx-post="/api/v1/teams"
        hx-target="#results"
        hx-triggrer="change"
        name="league_id"
      >
        <option disabled selected>
          League
        </option>
        {props.leagues.map((league) => {
          return <option value={league.league_id}>{league.league_name}</option>;
        })}
      </select>
      <div className="mt-5 flex" id="results"></div>
    </>
  );
};

app.get("/", async (c) => {
  let result: leagues[] = [];

  try {
    result = await prisma.leagues.findMany();
  } catch (error) {
    console.error(error);
    return c.json({ message: "something went wrong" }, 500);
  }

  return c.html(<View leagues={result} />);
});

export default app;
