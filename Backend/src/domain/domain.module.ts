import { Module } from "@nestjs/common";
import { TeamsModule } from "./teams/teams.module";
import { UsersModule } from "./users/users.module";
import { AuthModule } from "./auth/auth.module";
import { PollsModule } from "./polls/polls.module";
import { LocationsModule } from "./locations/locations.module";

@Module({
	imports: [TeamsModule, UsersModule, AuthModule, PollsModule, LocationsModule],
	exports: [TeamsModule, UsersModule, AuthModule, PollsModule, LocationsModule]
})
export class DomainModule {}
