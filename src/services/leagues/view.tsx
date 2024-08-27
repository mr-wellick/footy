import { FC } from "hono/jsx";
import { leagues } from "@prisma/client";

const Leagues: FC<{ leagues: leagues[] }> = (props) => {
  return (
    <select name="leagues" id="leagues">
      {props.leagues.map((leagues) => {
        return <option value={leagues.league_id}>{leagues.league_name}</option>;
      })}
    </select>
  );
};

export default Leagues;
