import Home from "./pages/Home";
import PlayerTable from "./components/PlayerTable";
import Login from "./pages/Login";
import Games from "./pages/Games";

// Any route which has a displayName will be displayed in the main navigation menu header.
export default [
  { path: "/", component: Home, name: "Home", displayName: "Home" },
  { path: "/players", component: PlayerTable, displayName: "Players" },
  { path: "/games", component: Games, displayName: "Games" },
  { path: "/login", component: Login, name: "Login" },
];
