import { Module } from "@nestjs/common";
import { TeamsRepository } from "./teams.repository";
import { UsersRepository } from "./users.repository";
import { AuthsRepository } from "./auths.repository";
import { UtilsModule } from "../../../utils/utils.module";
import { PollsRepository } from "./polls.repository";
import { LocationsRepository } from "./locations.repository";

@Module({
	exports: [
		TeamsRepository,
		UsersRepository,
		AuthsRepository,
		PollsRepository,
		LocationsRepository
	],
	providers: [
		TeamsRepository,
		UsersRepository,
		AuthsRepository,
		PollsRepository,
		LocationsRepository
	],
	imports: [UtilsModule]
})
export class FirebaseRepositoryModule {}
