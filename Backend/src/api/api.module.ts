import { Module } from "@nestjs/common";
import { TeamsAPIModule } from "./teams/teamsAPI.module";
import { UsersAPIModule } from "./users/usersAPI.module";
import { PollsAPIModule } from "./polls/pollsAPI.module";
import { LocationsAPIModule } from "./locations/locationsAPI.module";
import { MessagesAPIModule } from "./messages/messagesAPI.module";

@Module({
	imports: [TeamsAPIModule, UsersAPIModule, PollsAPIModule, LocationsAPIModule, MessagesAPIModule]
})
export class ApiModule {}
