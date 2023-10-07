import { Module } from "@nestjs/common";
import { TeamsAPIModule } from "./teams/teamsAPI.module";
import { UsersAPIModule } from "./users/usersAPI.module";
import { PollsAPIModule } from "./polls/pollsAPI.module";
import { LocationsAPIModule } from "./locations/locationsAPI.module";

@Module({
	imports: [TeamsAPIModule, UsersAPIModule, PollsAPIModule, LocationsAPIModule]
})
export class ApiModule {}
