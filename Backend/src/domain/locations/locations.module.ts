import { Module } from "@nestjs/common";
import { RepositoryModule } from "../../data/repositories/repository.module";
import { LocationsService } from "./locations.service";
import { TeamsModule } from "../teams/teams.module";
import { UsersModule } from "../users/users.module";

@Module({
    imports: [RepositoryModule, TeamsModule, UsersModule],
    exports: [LocationsService],
    providers: [LocationsService]
})
export class LocationsModule {}
