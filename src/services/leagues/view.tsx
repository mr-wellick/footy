import { FC } from "hono/jsx";
import { leagues } from "@prisma/client";

const Leagues: FC<{ leagues: leagues[] }> = (props) => {
  return (
    <select name="leagues" id="leagues">
      {props.leagues.map((league) => {
        return <option value={league.league_id}>{league.league_name}</option>;
      })}
    </select>
  );
};

export default Leagues;
