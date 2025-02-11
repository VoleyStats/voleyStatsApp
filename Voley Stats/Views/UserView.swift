import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import ProvisioningProfile
import StoreKit
import OSLog

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
    @EnvironmentObject var network : NetworkMonitor
    @Environment(\.dismiss) var dismiss
    @State var tab: String = "general".trad()
    @Namespace var animation
    var body: some View {
        VStack{
            HStack{
                ZStack{
                    Text(viewModel.avatar).font(.system(size: 70))//.scaledToFit().lineLimit(1).frame(width: 100, height: 100)
                }.frame(width: 100, height: 100).background(.white.opacity(0.1)).clipShape(Circle()).frame(maxWidth: .infinity, alignment: .center)
//                Image(systemName: "person.circle.fill").resizable().scaledToFit().frame(width: 100, height: 100).frame(maxWidth: .infinity, alignment: .center)
                VStack{
                    Text("\(Auth.auth().currentUser?.displayName ?? "")").font(.title).padding(.vertical).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(Auth.auth().currentUser?.email ?? "")").frame(maxWidth: .infinity, alignment: .leading).foregroundStyle(.gray)
                }.padding()
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()
            HStack{
                TabButton(selection: $tab, title: "general".trad(), animation: animation, action:{})
                TabButton(selection: $tab, title: "settings".trad(), animation: animation, action:{})
//                TabButton(selection: $viewModel.tab, title: "Set", animation: animation, action:{})
                
                
            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
            if tab == "general".trad(){
                VStack{
                    VStack{
                        ZStack{
                            Text("season".trad()).font(.title).frame(maxWidth: .infinity)
                            Image(systemName: "gearshape.fill").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture{
                                viewModel.manageSeasons.toggle()
                            }
                        }
                        Text("\(viewModel.activeSeason ?? "no.season".trad())").font(.system(size: 60))
                    }.padding().background(.blue).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
                        viewModel.manageSeasons.toggle()
                    }
                    HStack{
                        VStack{
                            ZStack{
                                Text("teams".trad()).font(.title).frame(maxWidth: .infinity)
                                Image(systemName: "gearshape.fill").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture{
                                    viewModel.arrangeTeams.toggle()
                                }
                            }
                            Text("\(Team.all().count)").font(.system(size: 60))
                        }.padding().background(.orange).clipShape(RoundedRectangle(cornerRadius: 15)).onTapGesture {
                            viewModel.arrangeTeams.toggle()
                        }
                        VStack{
                            Text("players".trad()).font(.title).frame(maxWidth: .infinity)
                            Text("\(Player.all().count)").font(.system(size: 60))
                        }.padding().background(.purple).clipShape(RoundedRectangle(cornerRadius: 15))
                    }.padding()
                    HStack{
                        VStack{
                            Text("tournaments".trad()).font(.title).frame(maxWidth: .infinity)
                            Text("\(Tournament.all().count)").font(.system(size: 60))
                        }.padding().background(.pink).clipShape(RoundedRectangle(cornerRadius: 15))
                        VStack{
                            Text("matches".trad()).font(.title).frame(maxWidth: .infinity)
                            Text("\(Match.all().count)").font(.system(size: 60))
                        }.padding().background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
                    }.padding()
//                    HStack{
//                        Text(viewModel.df.string(from: ProvisioningProfile.profile()?.expiryDate ?? .now))
//                    }.padding().background(.red.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 15))
                }.frame(maxHeight: .infinity, alignment: .top)
            }
            if tab == "settings".trad(){
                VStack{
                    HStack{
                        if viewModel.importing {
                            ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.cyan).frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            HStack{
                                Text("data.import".trad())
//                                if viewModel.pass{
                                Image(systemName: "square.and.arrow.down").padding(.horizontal)
//                                }else{
//                                    Image(systemName: "lock.fill").padding(.horizontal)
//                                }
                            }.frame(maxWidth: .infinity).foregroundStyle(.white)
                        }
                    }.padding().background(.white.opacity(network.isConnected ? 0.1 : 0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
                        if network.isConnected{
                            viewModel.importing = true
                            viewModel.importFromFirestore()
                            viewModel.pickSeason.toggle()
                        }
                    }
                    HStack{
                        if viewModel.saving{
                            ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.cyan).frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            HStack{
                                Text("data.export".trad())
                                if viewModel.pass{
                                    Image(systemName: "square.and.arrow.up").padding(.horizontal)
                                }else{
                                    Image(systemName: "lock.fill").padding(.horizontal)
                                }
                            }.frame(maxWidth: .infinity).foregroundStyle(viewModel.pass ? .white : .gray)
                        }
                    }.padding().background(.white.opacity(network.isConnected ? 0.1 : 0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
                        if network.isConnected && viewModel.pass{
                            viewModel.saving.toggle()
                            viewModel.saveFirestore()
                        }
                    }
                    
                    CollapsibleListElement(title: "language".trad()){
                        VStack{
                            HStack{
                                Text("spanish".trad()).frame(maxWidth: .infinity)
                                if viewModel.lang == "es" {
                                    Image(systemName: "checkmark.circle.fill").padding(.horizontal)
                                }
                            }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                viewModel.lang = "es"
                                UserDefaults.standard.set("es", forKey: "locale")
                                viewModel.langChanged.toggle()
                                self.tab = "settings".trad()
                            }
                            HStack{
                                Text("english".trad()).frame(maxWidth: .infinity)
                                if viewModel.lang == "en" {
                                    Image(systemName: "checkmark.circle.fill").padding(.horizontal)
                                }
                            }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                viewModel.lang = "en"
                                UserDefaults.standard.set("en", forKey: "locale")
                                viewModel.langChanged.toggle()
                                self.tab = "settings".trad()
                            }
                        }.padding()
                    }
                    HStack{
                        if viewModel.closing{
                            ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.cyan).frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            HStack{
                                Text("log.out".trad())
                                Image(systemName: "rectangle.portrait.and.arrow.right").padding(.horizontal)
                            }.frame(maxWidth: .infinity).foregroundStyle(network.isConnected ? .red : .gray)
                        }
                    }.padding().background(network.isConnected ? .red.opacity(0.1) : .white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
                        if network.isConnected{
                            viewModel.closing.toggle()
                            do{
                                try Auth.auth().signOut()
                                
                            } catch {
                                print("error")
                            }
                            dismiss()
                        }
                    }.disabled(!network.isConnected)
                    Text("delete.account".trad()).onTapGesture{
                        if network.isConnected{
                            viewModel.deleteAccount.toggle()
                        }
                    }.font(.footnote).frame(maxWidth: .infinity, alignment: .leading).foregroundStyle(.gray).padding(.horizontal)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            if !SeasonPass().active{
                HStack{
                    Text("buy.pass".trad()).font(.title2).frame(maxWidth: .infinity)//.foregroundStyle(Color.swatch.dark.high)
                    Image(systemName: "ticket.fill").resizable().aspectRatio(contentMode: .fill).rotationEffect(.degrees(-20)).foregroundStyle(.white.opacity(0.5))//.padding()
                }.padding().frame(height: 100).background(Color(hex: "#ffbf00") ?? .yellow).clipShape(RoundedRectangle(cornerRadius: 8)).padding().onTapGesture{
                    //                let s = SeasonPass()
                    //                if s.add(date: .now){
                    //                    Team.all().forEach{team in
                    //                        team.addPass()
                    //                    }
                    if Auth.auth().currentUser?.uid == "wdgnUenPMOQlO3Q4KrxFXF7suEF2"{
                        let s = SeasonPass()
                        if s.add(date: .now){
                            viewModel.teams.forEach{team in
                                team.addPass()
                            }
                            viewModel.pass = s.active
                        }
                        
                    }else{
                        withAnimation{
                            viewModel.showStore.toggle()
                        }
                    }
                    //                }
                }
            }else{
                HStack{
                    Text("\("active.pass.until".trad()): \(SeasonPass().endDate.formatted(date: .numeric, time: .omitted))").font(.title2).frame(maxWidth: .infinity)//.foregroundStyle(Color.swatch.dark.high)
                    Image(systemName: "ticket.fill").resizable().aspectRatio(contentMode: .fill).rotationEffect(.degrees(-20)).foregroundStyle(.white.opacity(0.5))//.padding()
                }.padding().frame(height: 100).background(Color(hex: "#ffbf00") ?? .yellow).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
            }
        }.background(Color.swatch.dark.high).foregroundStyle(.white)
            .navigationTitle("user.area".trad())
            
            .overlay(viewModel.arrangeTeams ? arrangeTeams() : nil)
            .overlay(viewModel.manageSeasons ? addSeason() : nil)
            .overlay(viewModel.pickSeason ? pickSeasonModal() : nil)
            .overlay(viewModel.newPass ? slidesModal() : nil)
            .overlay(viewModel.showStore ? storeModal() : nil)
            .overlay(viewModel.chooseTarget ? passTargetModal() : nil)
            .overlay(viewModel.deleteAccount ? deleteAccountModal() : nil)
            .toast(show: $viewModel.showToast, Toast(show: $viewModel.showToast, type: viewModel.toastType, message: viewModel.msg))
            
    }
    @ViewBuilder
    func arrangeTeams() ->some View{
        ZStack{
            Rectangle().fill(.black.opacity(0.7)).ignoresSafeArea()
            VStack{
                ZStack{
                    Text("manage.teams".trad()).frame(maxWidth: .infinity, alignment: .center)
                    Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                        viewModel.arrangeTeams.toggle()
                    }
                }.padding().font(.title)
                VStack{
                    ForEach(viewModel.teams, id:\.id){team in
                        HStack{
                            //                    Text("\(team.order)")
                            HStack{
                                
                                Image(systemName: "chevron.up").onTapGesture {
                                    if team.order != 1{
                                        withAnimation(.spring){
                                            team.order -= 1
                                            let prev = viewModel.teams[team.order-1]
                                            prev.order += 1
                                            if team.update() && prev.update(){
                                                viewModel.teams = Team.all()
                                            }
                                        }
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundStyle(team.order != 1 ? .white : .gray)
                                
                                Image(systemName: "chevron.down").onTapGesture {
                                    if team.order != viewModel.teams.count{
                                        withAnimation(.spring){
                                            team.order += 1
                                            let prev = viewModel.teams[team.order-1]
                                            prev.order -= 1
                                            if team.update() && prev.update(){
                                                viewModel.teams = Team.all()
                                            }
                                        }
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundStyle(team.order != viewModel.teams.count ? .white : .gray)
                            }//.frame(width: 70)
                            Text("\(team.name)").frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                            Image(systemName: "trash").foregroundStyle(.red).padding().background(.red.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }.padding()
            }.padding().foregroundStyle(.white).background(Color.swatch.dark.mid).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity, maxHeight: .infinity).padding()
        }
    }
    
    @ViewBuilder
    func addSeason() ->some View{
//        let season = Season.active()!
        ZStack{
            Rectangle().fill(.black.opacity(0.7)).ignoresSafeArea()
            VStack{
                ZStack{
                    Text("name.season".trad()).font(.title2).frame(maxWidth: .infinity, alignment: .center)
                    Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                        viewModel.manageSeasons.toggle()
                    }
                }.padding().font(.title)
                
                VStack(alignment: .leading){
                    //                Text("opponent".trad()).font(.caption)
                    TextField("season".trad(), text: $viewModel.seasonName).textFieldStyle(TextFieldDark())
                }.padding()
                HStack{
                    Image(systemName: "info.circle").padding(.trailing)
                    Text("add.season.message".trad()).frame(maxWidth: .infinity, alignment: .leading)
                }.padding()
                if !network.isConnected{
                    HStack{
                        Image(systemName: "exclamationmark.triangle").foregroundStyle(.yellow).padding(.trailing)
                        Text("add.season.network.message".trad()).frame(maxWidth: .infinity, alignment: .leading)
                    }.padding().background(.yellow.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
                }
                if viewModel.creating{
                    ProgressView().tint(.white).padding().frame(maxWidth: .infinity).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8))
                }else {
                    VStack{
                        HStack{
                            Text("keep.teams".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(.cyan).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                //                    season.delete(keepTeams: true)
                                viewModel.creating.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    viewModel.createSeason(backup: network.isConnected, keepTeams: true)
                                }
                                //                    if Season.create(season: Season(name: viewModel.seasonName), keepTeams: true) != nil{
                                //                        viewModel.seasons = Season.all()
                                //                        viewModel.newSeason.toggle()
                                //                    }
                            }
                            Text("keep.players".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(.cyan).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                //                    season.delete(keepPlayers: true)
                                viewModel.creating.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    viewModel.createSeason(backup: network.isConnected, keepPlayers: true)
                                }
                                //                    if Season.create(season: Season(name: viewModel.seasonName), keepPlayers: true) != nil{
                                //                        viewModel.seasons = Season.all()
                                //                        viewModel.newSeason.toggle()
                                //                    }
                            }
                        }
                        Text("start.scratch".trad()).padding().frame(maxWidth: .infinity).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            viewModel.creating.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                viewModel.createSeason(backup: network.isConnected)
                            }
                            //                if Season.create(season: Season(name: viewModel.seasonName)) != nil{
                            //                    viewModel.seasons = Season.all()
                            //                    viewModel.newSeason.toggle()
                            //                }
                        }
                        Text("rename.current.season".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(.cyan).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            //                    viewModel.creating.toggle()
                            UserDefaults.standard.set(viewModel.seasonName, forKey: "season")
                            viewModel.manageSeasons.toggle()
                            //                if Season.create(season: Season(name: viewModel.seasonName)) != nil{
                            //                    viewModel.seasons = Season.all()
                            //                    viewModel.newSeason.toggle()
                            //                }
                        }
                    }.padding()
                }
            }.padding().foregroundStyle(.white).background(Color.swatch.dark.mid).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity, maxHeight: .infinity).padding()
        }
    }
    
    @ViewBuilder
    func pickSeasonModal() -> some View {
        ZStack{
            Rectangle().fill(.black.opacity(0.7)).ignoresSafeArea()
            VStack{
                HStack{
                    Button(action:{
                        viewModel.pickSeason.toggle()
                        viewModel.importing = false
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("pick.season.restore".trad()).font(.title2).padding([.bottom, .horizontal])
                ForEach(viewModel.availableBackups, id: \.name){file in
                    Text(file.name.split(separator: "_").last?.split(separator: ".").first ?? "No season name").padding().frame(maxWidth: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal).onTapGesture {
                        viewModel.restoreDBFile(file: file)
                    }
                }
            }
            .padding()
            .foregroundStyle(.white)
            .background(Color.swatch.dark.mid)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }

    
    @ViewBuilder
    func slidesModal() -> some View {
            ZStack{
                Rectangle().fill(Color.swatch.dark.mid.opacity(0.5)).ignoresSafeArea()
                PresentationSlider(slides:[
                    Slide(title: "slide.export.title".trad(), subtitle: "slide.export.text".trad(), image: Image("slide_export")),
                    Slide(title: "slide.stats.title".trad(), subtitle: "slide.stats.text".trad().trad(), image: Image("slide_stats")),
                    Slide(title: "slide.fill.title".trad(), subtitle: "slide.fill.text".trad(), image: Image("slide_fill")),
                    Slide(title: "slide.backup.title".trad(), subtitle: "slide.backup.text", image: Image("slide_backup"))
                ], cta_text: "start.capturing".trad(), cta_action: {viewModel.newPass.toggle()}, skip_action: {viewModel.newPass.toggle()}).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center).padding()
            }.transition(.move(edge: .bottom))
    }
    
    @ViewBuilder
    func passTargetModal() -> some View {
        ZStack{
            Rectangle().fill(Color.swatch.dark.mid.opacity(0.7)).ignoresSafeArea()
            VStack{
                ZStack{
                    Text("pick.pass.target".trad()).font(.title2).padding().frame(maxWidth: .infinity)
                    Image(systemName: "multiply").font(.title2).padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                        withAnimation{
                            viewModel.chooseTarget.toggle()
                        }
                    }
                }.padding()
                VStack{
                    ForEach(viewModel.teams, id:\.id){team in
                        VStack{
                            Text(team.name.uppercased()).foregroundStyle(.gray).frame(maxWidth: .infinity, alignment: .leading)
                            if viewModel.passTarget == "tournament"{
                                ForEach(team.tournaments().filter{$0.pass == false}, id:\.id){tournament in
                                    HStack{
                                        Image(systemName: viewModel.selectedMatch == tournament ? "circle.fill" : "circle").padding(.horizontal)
                                        VStack{
                                            Text(tournament.name)
                                            Text("\(tournament.getStartDateString())-\(tournament.getEndDateString())")
                                        }
                                    }.padding().frame(maxWidth: .infinity, alignment: .leading).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture{
                                        viewModel.selectedTournament = tournament
                                    }
                                }
                            }else{
                                ForEach(team.matches().filter{$0.pass == false}, id:\.id){match in
                                    HStack{
                                        Image(systemName: viewModel.selectedMatch == match ? "circle.fill" : "circle").padding(.horizontal)
                                        VStack{
                                            Text(match.opponent)
                                            Text(match.date.formatted(.dateTime)).font(.subheadline)
                                        }
                                    }.padding().frame(maxWidth: .infinity, alignment: .leading).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture{
                                        viewModel.selectedMatch = match
                                    }
                                }
                            }
                        }.padding()
                    }
                }
                Text("add.pass".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(viewModel.selectedMatch != nil || viewModel.selectedTournament != nil ? .cyan : .gray).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture{
                    if viewModel.selectedTournament != nil{
                        viewModel.selectedTournament!.addPass()
                        withAnimation{
                            viewModel.chooseTarget.toggle()
                            viewModel.newPass.toggle()
                        }
                        viewModel.selectedTournament = nil
                    }
                    if viewModel.selectedMatch != nil{
                        viewModel.selectedMatch!.pass = true
                        viewModel.selectedMatch!.update()
                        withAnimation{
                            viewModel.chooseTarget.toggle()
                            viewModel.newPass.toggle()
                        }
                        viewModel.selectedMatch = nil
                    }
                }
            }.padding().frame(maxWidth: .infinity).background(Color.swatch.dark.high).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
        }
    }
    
    @ViewBuilder
    func storeModal() -> some View {
        ZStack(alignment: .bottom){
            Rectangle().fill(Color.swatch.dark.mid.opacity(0.5)).ignoresSafeArea()
            VStack{
                ZStack{
                    Text("buy.pass".trad()).font(.title2).padding().frame(maxWidth: .infinity)
                    Image(systemName: "multiply").font(.title2).padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                        withAnimation{
                            viewModel.showStore.toggle()
                        }
                    }
                }.padding()
                
//                ForEach(viewModel.productIds, id: \.0){id in
//                    ProductView(id: id.0){
//                        Image(systemName: id.1).resizable().scaledToFit().foregroundStyle(.cyan).padding(.horizontal)
//                    }.productViewStyle(.compact).padding().background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 8)).padding()
//                }
                StoreView(ids: viewModel.productIds.map(\.0))
                    .storeButton(.visible, for: .redeemCode, .policies)
                    .productViewStyle(.compact)
                    .storeButton(.hidden, for: .cancellation)
//                ProductView(id: "season.pass.full"){
////                    ZStack{
//                    Image(systemName: "ticket.fill").resizable().aspectRatio(contentMode: .fit).rotationEffect(.degrees(-20)).foregroundStyle(.cyan).padding().background(.white.opacity(0.1), in: Circle())
//                }.productViewStyle(.large).padding().background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 8)).padding()
//                HStack{
//                    if (viewModel.teams.flatMap{$0.tournaments().filter{$0.pass == false}}.count > 0){
//                        ProductView(id: "tournament.pass.full"){
//                            Image(systemName: "ticket.fill").resizable().scaledToFit().foregroundStyle(.cyan).padding()
//                        }.productViewStyle(.compact).padding().background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 8)).padding()
//                    }
//                    if (viewModel.teams.flatMap{$0.matches().filter{$0.pass == false}}.count > 0){
//                        ProductView(id: "match.pass.full"){
//                            Image(systemName: "ticket.fill").resizable().scaledToFit().foregroundStyle(.cyan)
//                        }.productViewStyle(.compact).padding().background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 8)).padding()
//                    }
//                }.padding()
//                StoreView(ids: ["tournament.pass.full", "match.pass.full"])
            }.frame(maxWidth: .infinity).background(Color.swatch.dark.high).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
        }.transition(.move(edge: .bottom))
            .onInAppPurchaseCompletion{product, result in
                print(result)
                if case .success(.success(let transaction)) = result{
                    if product.id == "season.pass.full"{
                        let s = SeasonPass()
                        if s.add(date: .now){
                            viewModel.teams.forEach{team in
                                team.addPass()
                            }
                            viewModel.pass = s.active
                        }
                        
                        viewModel.newPass.toggle()
                    }else{
                        viewModel.passTarget = String(product.id.split(separator: ".").first!)
                        viewModel.chooseTarget.toggle()
                    }
                    viewModel.showStore.toggle()
                
                    viewModel.makeToast(msg: "purchase.success".trad(), type: .success)
                }else{
                    viewModel.makeToast(msg: "purchase.error".trad(), type: .error)
                }
                
            }
            
    }
    
    @ViewBuilder
    func deleteAccountModal() -> some View {
        ZStack{
            Rectangle().fill(Color.swatch.dark.mid.opacity(0.7)).ignoresSafeArea()
            VStack{
                ZStack{
                    Text("delete.account".trad()).font(.title2).padding().frame(maxWidth: .infinity)
                    Image(systemName: "multiply").font(.title2).padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                        withAnimation{
                            viewModel.deleteAccount.toggle()
                        }
                    }
                }
                Text("delete.account.message".trad()).padding(.bottom)
                
                VStack{
                    Text("delete.account.password".trad()).frame(maxWidth: .infinity, alignment: .leading)
                    ZStack{
                        if viewModel.secured {
                            SecureField("password".trad(), text: $viewModel.password).textFieldStyle(TextFieldDark()).textInputAutocapitalization(.never)
                        }else{
                            TextField("password".trad(), text: $viewModel.password).textFieldStyle(TextFieldDark()).textInputAutocapitalization(.never)
                        }
                        Image(systemName: viewModel.secured ? "eye.slash" : "eye").padding().frame(maxWidth: .infinity, alignment: .trailing).onTapGesture{
                            viewModel.secured.toggle()
                        }
                    }
                }.padding()
                HStack{
                    Text("cancel".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(.cyan).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture{
                        viewModel.deleteAccount.toggle()
                    }
                    Text("delete".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(.red).background(.red.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture{
                        if network.isConnected{
                            let user = Auth.auth().currentUser!
                            var credential: AuthCredential = EmailAuthProvider.credential(withEmail: user.email!, password: viewModel.password)
                            user.reauthenticate(with: credential){auth, error in
                                if error == nil{
                                    user.delete{error in
                                        if let error = error{
                                            viewModel.makeToast(msg: "delete.account.error".trad(), type: .error)
                                        }else{
                                            viewModel.makeToast(msg: "delete.account.success".trad(), type: .success)
                                        }
                                        viewModel.deleteAccount.toggle()
                                        dismiss()
                                    }
                                }
                                
                            }
                            
                            
                        }
                    }
                }
            }.padding().frame(maxWidth: .infinity).background(Color.swatch.dark.high).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
        }
    }
}
class UserViewModel: ObservableObject{
    @Published var lang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @Published var langChanged:Bool = false
    @Published var saving:Bool = false
    @Published var importing:Bool = false
    @Published var closing:Bool = false
    @Published var showToast: Bool = false
    @Published var toastType: ToastType = .success
    @Published var msg: String = ""
    @Published var countTransferred: Int = 0
    @Published var teams: [Team] = Team.all()
    @Published var arrangeTeams: Bool = false
    @Published var activeSeason:String? = UserDefaults.standard.string(forKey: "season")
    @Published var manageSeasons: Bool = false
    @Published var creating: Bool = false
    @Published var avatar: String
    @Published var availableBackups: [StorageReference] = []
    @Published var pickSeason: Bool = false
    @Published var newPass: Bool = false
    @Published var showStore: Bool = false
    @Published var chooseTarget: Bool = false
    @Published var passTarget: String = "match"
    @Published var selectedMatch: Match? = nil
    @Published var selectedTournament: Tournament? = nil
    @Published var deleteAccount: Bool = false
    @Published var secured: Bool = true
    @Published var password: String = ""
    var pass: Bool = SeasonPass().active
    var productIds: [(String, String)] = [("season.pass.full", "ticket.fill")]
    private let logger = Logger(
        subsystem: "Voley Stats",
        category: "stats store"
    )
//    @Published var newSeason: Bool = false
    @Published var seasonName: String = "\("season".trad()) \(Date.now.formatted(.dateTime.year()))-\(Calendar.current.date(byAdding: .year, value: 1, to: Date.init())?.formatted(.dateTime.year()) ?? Date.now.formatted(.dateTime.year()))"
    init(){
        let a = UserDefaults.standard.string(forKey: "avatar")
        avatar = a ?? String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
        if a == nil {
            UserDefaults.standard.set(avatar, forKey: "avatar")
        }
        if (teams.flatMap{$0.tournaments().filter{!$0.pass}}.count > 0){
            productIds.append(("tournament.pass.full", "trophy.fill"))
        }
        if(teams.flatMap{$0.matches().filter{!$0.pass}}.count > 0){
            productIds.append(("match.pass.full", "ecg.text.page.fill"))
        }
    }
    
    
    func process(transaction verificationResult: VerificationResult<StoreKit.Transaction>) async {
        do {
            let unsafeTransaction = verificationResult.unsafePayloadValue
            logger.log("""
            Processing transaction ID \(unsafeTransaction.id) for \
            \(unsafeTransaction.productID)
            """)
        }
        
        let transaction: StoreKit.Transaction
        switch verificationResult {
            case .verified(let t):
                logger.debug("""
                Transaction ID \(t.id) for \(t.productID) is verified
                """)
                transaction = t
            case .unverified(let t, let error):
                // Log failure and ignore unverified transactions
                logger.error("""
                Transaction ID \(t.id) for \(t.productID) is unverified: \(error)
                """)
                return
        }

        // We only need to handle consumables here. We will check the
        // subscription status each time before unlocking a premium subscription
        // feature.
        if case .consumable = transaction.productType {
            
            // The safest practice here is to send the transaction to your
            // server to validate the JWS and keep a ledger of the bird food
            // each account is entitled to. Since this is just a demonstration,
            // we are going to rely on StoreKit's automatic validation and
            // use SwiftData to keep a ledger of the bird food.
            
//            guard let (birdFood, product) = birdFood(for: transaction.productID) else {
//                logger.fault("""
//                Attempting to grant access to \(transaction.productID) for \
//                transaction ID \(transaction.id) but failed to query for
//                corresponding bird food model.
//                """)
//                return
//            }
//            
//            let delta = product.quantity * transaction.purchasedQuantity
            
            if transaction.revocationDate == nil, transaction.revocationReason == nil {
                // SwiftData crashes when we do this, so we'll save this for later
                //                if birdFood.finishedTransactions.contains(transaction.id) {
                //                    logger.log("""
                //                    Ignoring unrevoked transaction ID \(transaction.id) for \
                //                    \(transaction.productID) because we have already added \
                //                    \(birdFood.id) for the transaction.
                //                    """)
                //                    return
                //                }
                
                // This doesn't appear to actually be updating the model
//                birdFood.ownedQuantity += delta
                //                birdFood.finishedTransactions.insert(transaction.id)
                
//                logger.log("""
//                Added \(delta) \(birdFood.id)(s) from transaction ID \
//                \(transaction.id). New total quantity: \(birdFood.ownedQuantity)
//                """)
                
                // Finish the transaction after granting the user content
                await transaction.finish()
                
                logger.debug("""
                Finished transaction ID \(transaction.id) for \
                \(transaction.productID)
                """)
            } else {
//                birdFood.ownedQuantity -= delta
                
//                logger.log("""
//                Removed \(delta) \(birdFood.id)(s) because transaction ID \
//                \(transaction.id) was revoked due to \
//                \(transaction.revocationReason?.localizedDescription ?? "unknown"). \
//                New total quantity: \(birdFood.ownedQuantity).
//                """)
            }
        } else {
            // We can just finish the transction since we will grant access to
            // the subscription based on the subscription status.
            await transaction.finish()
        }
        
//        do {
//            try modelContext.save()
//        } catch {
//            logger.error("Could not save model context: \(error.localizedDescription)")
//        }
    }
    
    func makeToast(msg: String, type: ToastType){
        self.msg = msg
        self.toastType = type
        self.showToast.toggle()
    
    }
    func saveFirestore(){
        let db = Firestore.firestore()
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser!.uid
//        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let dirPath = AppGroup.database.containerURL.appendingPathComponent("database")
            
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent("db.sqlite")
                storage.child("\(uid)_\(activeSeason ?? seasonName).sqlite").putFile(from: dbPath)
                self.saving.toggle()
                self.makeToast(msg: "backup.saved".trad(), type: .success)
                print("SQLiteDataStore upload from: \(dbPath) ")
            } catch {
                self.saving.toggle()
                self.makeToast(msg: "backup.error".trad(), type: .error)
                print("SQLiteDataStore init error: \(error)")
            }
//        } else {
//            self.saving.toggle()
//            self.makeToast(msg: "backup.error".trad(), type: .error)
//        }
    }
    func importFromFirestore(){
//        DB.truncateDatabase()
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser!.uid
//        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = AppGroup.database.containerURL.appendingPathComponent("database")
            
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent("db.sqlite")
                storage.listAll(){files, err in
                    if let err = err{
                        self.pickSeason.toggle()
                        self.importing.toggle()
                        
                        self.makeToast(msg: "error.importing".trad(), type: .error)
                    }else{
                        self.availableBackups = files!.items.filter{$0.name.contains(uid) && !$0.name.contains(self.activeSeason ?? self.seasonName)}
                    }
                }
//                storage.child("\(uid)_\(activeSeason ?? seasonName).sqlite").write(toFile: dbPath){url, err in
//                    if let err = err {
//                        self.importing.toggle()
//                        self.makeToast(msg: "error.importing".trad(), type: .error)
//                    }else{
//                        self.importing.toggle()
//                        self.makeToast(msg: "data.imported".trad(), type: .success)
//                        DB.shared = DB()
//                        print("SQLiteDataStore upload from: \(dbPath) ")
//                    }
//                }
                
            } catch {
                self.pickSeason.toggle()
                self.importing.toggle()
                self.makeToast(msg: "error.importing".trad(), type: .error)
                print("SQLiteDataStore init error: \(error)")
            }
//        } else {
//            self.importing.toggle()
//            self.makeToast(msg: "error.importing".trad(), type: .error)
//        }
    }
    
    func restoreDBFile(file: StorageReference){
        
        let dirPath = AppGroup.database.containerURL.appendingPathComponent("database")
        do {
            try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
            let dbPath = dirPath.appendingPathComponent("db.sqlite")

                file.write(toFile: dbPath){url, err in
                    if let err = err {
                        self.pickSeason.toggle()
                        self.importing.toggle()
                        
                        self.makeToast(msg: "error.importing".trad(), type: .error)
                    }else{
                        self.pickSeason.toggle()
                        self.importing.toggle()
                        
                        self.makeToast(msg: "data.imported".trad(), type: .success)
                        DB.shared = DB()
                        print("SQLiteDataStore upload from: \(dbPath) ")
                        self.seasonName = "\(file.name.split(separator: "_").last?.split(separator: ".").first ?? "No season name")"
                        UserDefaults.standard.set(self.seasonName, forKey: "season")
                        self.pass = SeasonPass().active
                    }
                }
            
        } catch {
            self.pickSeason.toggle()
            self.importing.toggle()
            
            self.makeToast(msg: "error.importing".trad(), type: .error)
            print("SQLiteDataStore init error: \(error)")
        }
    }
    
    func createSeason(backup: Bool, keepTeams: Bool = false, keepPlayers: Bool = false){
            //TODO: add loading state
            if backup{
                print("saving")
                self.saveFirestore()
            }
            if keepTeams{
                Match.truncate()
                Tournament.truncate()
                Rotation.truncate()
                Team.all().forEach{
                    $0.seasonEnd = .distantPast
                    $0.pass = false
                    $0.update()
                }
                SeasonPass().reset()
            }else if keepPlayers {
                Team.all().forEach{$0.delete(deletePlayers: false)}
            }else{
                DB.truncateDatabase()
            }
            UserDefaults.standard.set(self.seasonName, forKey: "season")
            self.creating.toggle()
//            self.newSeason.toggle()
            self.manageSeasons.toggle()
        }
    
    func newImport(){
        self.countTransferred += 1
        if self.countTransferred == 9{
            self.importing.toggle()
            self.makeToast(msg: "data.imported".trad(), type: .success)
        }
    }
    
}
