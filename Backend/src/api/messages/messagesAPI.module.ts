import { Module } from "@nestjs/common";
import { MessagesController } from "./messages.controller";
import { DomainModule } from "../../domain/domain.module";

@Module({
imports: [DomainModule],
controllers: [MessagesController]
})
export class MessagesAPIModule {}
