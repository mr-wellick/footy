import { FC, useEffect, useState } from "hono/jsx";

const Leagues: FC = () => {
  const [data, setData] = useState([]);
  const [teams, setTeams] = useState([]);
  const [players, setPlayers] = useState([]);

  useEffect(() => {
    fetch("http://localhost:3000/api/v1/leagues")
      .then((res) => res.json())
      .then((data) => setData(data))
      .catch((error) => console.log(error));
  }, []);

  return (
    <div class="flex">
      <select
        className="select select-primary w-full max-w-xs"
        onChange={(e) => {
          fetch("http://localhost:3000/api/v1/teams", {
            method: "POST",
            body: JSON.stringify({
              league_id: e.target.value,
            }),
          })
            .then((res) => res.json())
            .then((data) => setTeams(data))
            .catch((error) => console.log(error));
        }}
      >
        <option disabled selected>
          choose a league
        </option>
        {data.map((league) => {
          return <option value={league.league_id}>{league.league_name}</option>;
        })}
      </select>
      {teams.length > 0 ? (
        <div className="overflow-x-auto">
          <table className="table table-xs">
            <thead>
              <tr>
                <td></td>
                <th>Team</th>
                <th>Players</th>
              </tr>
            </thead>
            <tbody>
              {teams.map((team, index) => {
                return (
                  <tr>
                    <td>{index + 1}</td>
                    <td>{team.name}</td>
                    <td
                      data-team-id={team.team_id}
                      onClick={(e) => {
                        document.getElementById("my_modal_1").showModal();
                        fetch(
                          "http://localhost:3000/api/v1/players/statistics",
                          {
                            method: "POST",
                            body: JSON.stringify({
                              team_id: (e.target as HTMLTableRowElement).dataset
                                .teamId,
                            }),
                          }
                        )
                          .then((res) => res.json())
                          .then((data) => setPlayers(data))
                          .catch(console.log);
                      }}
                    >
                      View Players
                    </td>
                  </tr>
                );
              })}
            </tbody>
            <tfoot>
              <tr>
                <td></td>
                <th>Team</th>
                <th>Players</th>
              </tr>
            </tfoot>
          </table>
        </div>
      ) : null}

      <dialog id="my_modal_1" className="modal">
        <div className="modal-box">
          <h3 className="font-bold text-lg">Hello!</h3>
          <p className="py-4">{JSON.stringify(players)}</p>
          <div className="modal-action">
            <form method="dialog">
              {/* if there is a button in form, it will close the modal */}
              <button className="btn">Close</button>
            </form>
          </div>
        </div>
      </dialog>
    </div>
  );
};

const Hero: FC = () => {
  return (
    <div className="bg-base-200 min-h-screen">
      <Leagues />
    </div>
  );
};

export default Hero;
