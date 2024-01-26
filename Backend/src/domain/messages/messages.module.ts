import { Module } from "@nestjs/common";
import { RepositoryModule } from "../../data/repositories/repository.module";
import { MessagesService } from "./messages.service";
import { TeamsModule } from "../teams/teams.module";
import { UsersModule } from "../users/users.module";

@Module({
imports: [RepositoryModule, TeamsModule, UsersModule],
exports: [MessagesService],
providers: [MessagesService]
})
export class MessagesModule {}
