import HomePage from "./pages/Home";
import PlayerTable from "./components/PlayerTable";

export default [
  { path: "/", component: HomePage, displayName: "Home" },
  { path: "/players", component: PlayerTable, displayName: "Players" },
  { path: "/games", component: null, displayName: "Games" }
];
