import { FC } from "hono/jsx";
import { leagues } from "@prisma/client";

const Leagues: FC<{ leagues: leagues[] }> = (props) => {
  return (
    <select class="select select-accent w-full max-w-xs">
      <option disabled selected>
        League
      </option>
      {props.leagues.map((league) => {
        return <option value={league.league_id}>{league.league_name}</option>;
      })}
    </select>
  );
};

export default Leagues;
