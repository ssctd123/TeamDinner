import { Module } from "@nestjs/common";
import { RepositoryModule } from "../../data/repositories/repository.module";
import { LocationsService } from "./locations.service";
import { TeamsModule } from "../teams/teams.module";

@Module({
    imports: [RepositoryModule, TeamsModule],
    exports: [LocationsService],
    providers: [LocationsService]
})
export class PollsModule {}
